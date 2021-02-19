class ProgressListsController < ApplicationController
  def create
    progress_list = ProgressList.new(progress_list_params)
    progress_list.user_id = current_user.id
    progress_list.save
  end

  def progress_list_params
    params.require(:progress_list).permit(
      :body,
      :checklist_id
    )
  end

end
