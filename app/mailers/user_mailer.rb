# frozen_string_literal: true

class UserMailer < ApplicationMailer
  # Report about a finished CSV import, sent to the admin who started it.
  def import_report(user, import)
    @user = user
    @import = import
    mail to: user.email, subject: "Books import ##{import.id}: #{import.status}"
  end
end
