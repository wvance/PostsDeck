class EmailapiController < ApplicationController

  def index
  end

  def subscribe
    @list_id = ENV["mail_chimp_list_id"]
    gb = Gibbon::Request.new

    # gb.lists.subscribe({
    #   :id => @list_id,
    #   :email => {:email => params[:email][:address]}
    # })
    # gibbon.lists.subscribe({:id => list_id, :email => {:email => "foo@bar.com"}, :merge_vars => {:FNAME => "Bob", :LNAME => "Smith"}})

    gb.lists(@list_id).members.create(
      body: {
        email_address: params[:email][:address],
        status: "subscribed"
      }
    )
    # gibbon.lists(list_id).members.create(body: {email_address: "foo@bar.com", status: "subscribed", merge_fields: {FNAME: "Bob", LNAME: "Smith"}})

    respond_to do |format|
      format.json{render :json => {:message => "You have been Successfully added to the list! :)"}}
    end
  end
end
