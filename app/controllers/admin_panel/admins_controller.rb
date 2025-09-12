# frozen_string_literal: true

module AdminPanel
  class AdminsController < AdminPanel::CrudController
    before_action :set_entity, only: %i[show edit update destroy]

    def index
      @q = Admin.order(id: :desc).ransack(params[:q])
      @total = @q.result.count
      @pagy, @entities = pagy(@q.result, params: pagination_params)
    end

    def show; end

    def new
      @entity = Admin.new
    end

    def edit; end

    def create
      @entity = Admin.new(entity_params)

      if @entity.save
        redirect_to url_for(action: :edit, id: @entity.id), notice: 'Admin was successfully created'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      admin_params = entity_params
      if admin_params[:password].blank?
        admin_params = admin_params.except(:password, :password_confirmation, :current_password)
      end
      if @entity.update(admin_params)
        redirect_to url_for(action: :index), notice: "Admin #{@entity.email} was successfully updated"
      else
        render :edit
      end
    end

    def destroy
      if @entity.destroy
        redirect_to url_for(action: :index), notice: 'Admin was successfully deleted'
      else
        redirect_to url_for(action: :index), alert: @entity.errors.full_messages.join('. ')
      end
    end

    private

    def entity_params
      params.expect(admin: %i[email first_name last_name password password_confirmation
                              current_password])
    end

    def set_entity
      @entity = Admin.find(params[:id])
    end
  end
end
