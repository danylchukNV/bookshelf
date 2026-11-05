# frozen_string_literal: true

module AdminPanel
  class ImportsController < AdminPanel::BaseController
    MAX_FILE_SIZE = 1.megabyte

    def index
      @pagy, @imports = pagy(Import.includes(:admin).order(id: :desc), limit: 20)
    end

    def show
      @import = Import.find(params[:id])
    end

    def new; end

    def create
      file = params[:file]
      return redirect_to(new_admin_import_path, alert: 'Please choose a CSV file.') if file.blank?
      unless File.extname(file.original_filename).casecmp?('.csv')
        return redirect_to(new_admin_import_path, alert: 'Only .csv files are allowed.')
      end
      return redirect_to(new_admin_import_path, alert: 'File is too large (max 1 MB).') if file.size > MAX_FILE_SIZE

      import = current_admin.imports.create!(filename: file.original_filename)
      # In development the :inline adapter runs the job immediately;
      # with Solid Queue it is executed by a separate worker process.
      ImportBooksJob.perform_later(import.id, file.read)

      redirect_to admin_import_path(import), notice: "Import ##{import.id} was started."
    end
  end
end
