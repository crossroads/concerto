class SubmissionsController < ApplicationController

  def index
    @submissions = Submission.where(:feed_id => params[:feed_id]).pending
  end

  def show
    @submission = Submission.find(params[:id])
  end

  # PUT /feeds/1/submission/1/approve
  def approve
    submission = Submission.find(params[:id])
    respond_to do |format|
      if submission.approve(User.find(params[:user_id]), params[:submission][:duration])
        format.html { redirect_to(feed_submissions_path, :notice => t(:content_approved)) }
      else
        format.html { redirect_to(feed_submission_path, :notice => t(:content_failed_approve)) }
      end
    end
  end
  
  # PUT /feeds/1/submission/1/deny
  def deny
    submission = Submission.find(params[:id])
    respond_to do |format|
      if submission.deny(User.find(params[:user_id]))
        format.html { redirect_to(feed_submissions_path, :notice => t(:content_denied)) }
      else
        logger.debug submission.errors
        format.html { redirect_to(feed_submission_path, :notice => t(:content_failed_deny)) }
      end
    end
  end

end
