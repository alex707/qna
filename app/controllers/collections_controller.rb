class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resource

  def destroy
    if current_user.author?(@resource)
      @attached.purge
      flash.now[:notice] = 'Your files successfully removed.'
    else
      flash.now[:alert] = 'Only owner can remove files of his resource.'
    end
  end

  private

  def load_resource
    @attached = ActiveStorage::Attachment.find(params[:id])
    @resource = Question.joins(:files_attachments).where(
      active_storage_attachments: { id: @attached.id }
    ).first
  end
end
