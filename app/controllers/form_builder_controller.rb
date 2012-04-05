require 'fileutils'

class FormBuilderController < ApplicationController
  before_filter :check_for_form, :only=>[:new_form]
  before_filter :check_signed_in
  before_filter :check_locked, :only=>[:lock_form]
  before_filter :check_locked_on_open, :only=>[:open_form]
  
    
  def reorder_elements
	  order=params[:order]
	  orderArray=order.split('_')  
	  @form=Form.find(session[:form_id])
	  reorder_form(@form,orderArray)
	  render :text=> "Done"
  end
  
  def reorder_form(form,orderArray)
	  i=0
	  orderArray.each do |order|
		  i=i+1
		  current_element=form.elements.find_by_id(order)
		  current_element.update_attributes(:position=> i)
	  end  
  end
  
  def new_form
    @categories=Category.where("title!=?","Label")
    @form=Form.find(session[:form_id])
    @elements=@form.elements.order(:position);
  end
  
  def lock_form
  	p "In locked form!!!!!!!!!!"	
    fieldArray=Array.new
    user=current_user
    form_id=session[:form_id]
    @form=Form.find(form_id)
    @form.elements.each do |element|
    	if(element.category_id!=1)
    	 	fieldArray<< clean_field_name(element.name)
    	end
    end
    @form.locked=true
    @form.save
    #p fieldArray
    #p user
    #p form_id
    model_name="User"+user.id.to_s+"Form"+form_id.to_s
    query= "rails generate model "+model_name+"Request "+send_fields(fieldArray)
    puts "************************"
    puts query
    #system query
    #system 'rake db:migrate'
    session[:form_id]=nil
   	respond_to do |format|
  		format.html{ redirect_to root_path, :notice=> "Form changes have been saved and form has been locked."}
  	end  	
  end
  
  def send_fields(fieldArray)
  	abc=""
  	fieldArray.each do |a|
  		abc+=a
  		abc+=" string "
  	end
  	return abc
  
  end

  def open_form
    @categories=Category.where("title!=?","Label")
    @form=Form.find(params[:openForm])
    session[:form_id]=@form.id
    @elements=@form.elements.order(:position);
    
    p @elements

  end

  def index
    @form = Form.new
    session[:form_id]=nil
    @forms=Form.where("user_id=?",current_user.id)
  end

  def save_form
    form_id=session[:form_id]
    user_id=current_user.id
    base_path=Dir::pwd+ "/xml"
    user_path=base_path +"/user_" +user_id.to_s
    save_path=user_path +"/form_" + form_id.to_s + ".xml"
    #Create the directory structure
    create_directories(base_path, user_path)
    xmlResp=""
    xmlResp=generate_response(form_id)
    #Create an XML template of the form
    xml_file=File.new(save_path,"w")
    xml_file.write(xmlResp)
    xml_file.close
    #session[:form_id]=nil
    respond_to do |format|
    	format.js
    end
  end
  
  

  def delete_form
  
    begin
      @form=Form.find(params[:id])
      session[:form_id]=nil
      if @form.destroy
        redirect_to root_path, :notice=> "Form Successfully Deleted"
      else
        render :new_form
      end
    rescue
      redirect_to form_builder_new_path, :notice=> "Form Unavailable"
    end
    
  end

  def new
    @form = Form.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @form }
    end
  end

  def login
    user_name=params[:username]
    password=params[:password]
    begin
      @user=User.find_first_by_auth_conditions(:email=>user_name)

      if @user.valid_password?(password)
        get_forms(@user.id)
      else

        render :text=>"Login Failed"
      end
    rescue
      render :text=> "Login Failed"
    end
  end
  
  def edit_elements
    concat_id=params[:id]
    puts concat_id
    ids=concat_id.split("_")
    field_id=ids[1] 
  end

  def delete_elements
    concat_id=params[:id]
    puts concat_id
    ids=concat_id.split("_")
    ids.each do |id|
		@element=Element.find(id)
		p @element
		@element.destroy
    end
    @title="#"+concat_id
    respond_to do |format|
        format.js
    end
  end

  # POST
  # POST
  def create
    @form=Form.new(params[:form])
    user_id=current_user.id
    secret_key=rand(1000000)
    @form.update_attributes(:user_id=> user_id, :secret_key=> secret_key)
    respond_to do |format|
      if @form.save
        session[:form_id]=@form.id
        format.html { redirect_to form_builder_new_form_path, :notice => 'Form was successfully created.' }
        format.json { render :json => @form, :status => :created, :location => @form }
      else
        format.html { render :action => "new" }
        format.json { render :json => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  def save_data
    @element_label=Element.new
    @element=Element.new(params[:data])
    @element_label.update_attributes(:name=> params[:data][:name], :category_id=>1 ,:form_id=> params[:data][:form_id], :width=> params[:data][:width], :height=> params[:data][:height])
    if @element.save
      respond_to do |format|
        format.js
      end
    else
      @element_label.destroy
      puts "Element couldnot be saved"
      redirect_to root_path
    end
  end

  #Show all forms for a particular user
  def get_forms(user_id)
    begin
      puts "In here"
      forms_xml=""
      @forms=Form.where("user_id=?",user_id)
      forms_xml<< "<forms>"
      @forms.each do |form|
        forms_xml<< '<form id="'+form.id.to_s+'">'
        forms_xml<< form.title
        forms_xml<<"</form>"

      end
      forms_xml<<"</forms>"
      puts forms_xml
      render :xml=> forms_xml
    rescue
      render :text=> "failure"
    end
  end

  #Send back the layout of a selected form
  def get_xml
    begin
      xmlResp=""
      form_id=params[:form_id]
      xmlResp=generate_response(form_id)
      render :xml=> xmlResp
    rescue
      render :text=>"Failure"
    end
  end


private

  def generate_response(form_id)
    xmlResp=""
    @form=Form.find(form_id)
    @elements=@form.elements.order(:position)
    xmlResp<< "<form id='#{@form.id}'>"
    xmlResp<< "<Title name= '#{@form.title}' />"
    xmlResp<< "<Image src='http://172.20.4.112:4000/system/images/#{@form.id}/small/#{@form.image_file_name}'/>"
    @elements.each do |e|
      xmlResp<< createXMLString(e)
    end
    xmlResp<< "</form>"
    return xmlResp
  end

  def check_for_form
    unless session[:form_id]
      redirect_to form_builder_new_path, :notice=> "Please create a form first"
    end
  end

  def createXMLString(e)
    if e.category_id==1
      "<#{e.category.title} width='#{e.width}' height='#{e.height}' name='#{e.name}' position='#{e.position}'></#{e.category.title}>"
    elsif e.category_id==2
      "<#{e.category.title} width='#{e.width}' height='#{e.height}' name='#{e.name}' input='#{e.input}' length='#{e.length}' position='#{e.position}'></#{e.category.title}>"
    elsif e.category_id==3
      "<#{e.category.title} width='#{e.width}' height='#{e.height}' name='#{e.name}' entries='#{e.entries}' position='#{e.position}'></#{e.category.title}>"
    elsif e.category_id==4
      "<#{e.category.title} width='#{e.width}' height='#{e.height}' name='#{e.name}' entries='#{e.entries}' position='#{e.position}'></#{e.category.title}>"
    end
  end
  
  def clean_field_name(name)
  	name=name.gsub(' ','_')
  	name=name.downcase
  	return name
  end
  
  def check_locked
  	@form=Form.find(session[:form_id])
  	p "In check locked"
  	p @form.locked?
  	if @form.locked?
  		redirect_to root_path
  	end
  end
  
  def check_locked_on_open
    @form=Form.find(params[:openForm])
    p "45454545908324948328"
    p @form
    if @form.locked?
        puts "In here"
    	redirect_to root_path
    end
  end
  
  def check_signed_in
  	unless user_signed_in?
  		redirect_to user_session_path
  	end
  end
   
end
