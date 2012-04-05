require 'fileutils'
require 'RMagick'
require 'xmlsimple'
class RequestsController < ApplicationController
  # GET /requests
  # GET /requests.json
  require 'json'
  def index
    @requests = Request.all
    puts "######################"
    puts "**********************"
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @requests }
    end
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    @request = Request.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @request }
    end
  end

  # GET /requests/new
  # GET /requests/new.json
  def new
    @request = Request.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @request }
    end
  end

  # GET /requests/1/edit
  def edit
    @request = Request.find(params[:id])
  end

  # POST /requests
  # POST /requests.json
  def create
    puts "Received request"
    
    @request = Request.new(params[:request])

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, :notice => 'Request was successfully created.' }
        format.json { render :json => @request, :status => :created, :location => @request }
      else
        format.html { render :action => "new" }
        format.json { render :json => @request.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def saveimage
    puts "In here"
    p params[:my_photo]
    
    my_json='{"PinCode":"yyfdd","Languages Known":["C"," C++"," Java"],"State":"gtfe","Profession":"Student","Gender":"Male","Address Line 1":"rfgh","Address Line 3":"ttff","Address Line 2":"ertg","Country":"ytfdf","Middle Name":"sdt","Last Name":"ety","First Name":"number1"}'
    parsed_json=ActiveSupport::JSON.decode(my_json)
    languages_known=""
    parsed_json["Languages Known"].each do |lang|
      languages_known+=lang
    end
    p languages_known
    p parsed_json["PinCode"]
    @request=Request.new
    @request.update_attributes(:first_name=>parsed_json["First Name"],:middle_name=>parsed_json["Middle Name"], :last_name=>parsed_json["Last Name"],:address_1=> parsed_json["Address Line 1"],:address_2=>parsed_json["Address Line 2"],:address_3=>parsed_json["Address Line 3"],:languages_known=>languages_known,:profession=>parsed_json["Profession"],:state=>parsed_json["State"],:country=>parsed_json["Country"], :gender=>parsed_json["Gender"], :pincode=>parsed_json["PinCode"])
    if @request.save
    begin   
    filepath= Dir::pwd + "/" + "app" + "/" +"assets" + "/" + "saved_images" + "/" + @request.id.to_s
    p filepath
    FileUtils.mkdir(filepath)
    rescue 
       puts "The folder didnt exist so created one" 
       filepath= Dir::pwd + "/" + "app" + "/" +"assets" + "/" + "saved_images"
       FileUtils.mkdir(filepath)
       filepath= Dir::pwd + "/" + "app" + "/" +"assets" + "/" + "saved_images" + "/" + @request.id.to_s
       FileUtils.mkdir(filepath)
     end
    end
  end
  
  #Save Data to a table
  
  #Initially used to save data to XML File
  def savejson
    user_id=2
    form_id=22
    tempXml=Hash.new
    @categories=Category.where("title!=?","Label")    
    my_json='{"PinCode":"yyfdd","Languages Known":["C"," C++"," Java"],"State":"gtfe","Profession":"Student","Gender":"Male","Address Line 1":"rfgh","Address Line 3":"ttff","Address Line 2":"ertg","Country":"ytfdf","Middle Name":"sdt","Last Name":"ety","First Name":"number1"}'
    parsed_json=ActiveSupport::JSON.decode(my_json)
    languages_known=""
    parsed_json["Languages Known"].each do |lang|
      languages_known+=lang
    end
    parsed_json["Languages Known"]=languages_known
    base_path=Dir::pwd+ "/xml"
    user_path=base_path +"/user_" +user_id.to_s
    save_path=user_path +"/form_" + form_id.to_s + ".xml"
    
    
    base_path_2=Dir::pwd+ "/data"
    user_path_2=base_path_2 +"/user_" +user_id.to_s
    save_path_2=user_path_2 +"/form_" + form_id.to_s + ".xml"
    create_directories(base_path_2,user_path_2)
    
    data=XmlSimple.xml_in(save_path)
    #Put data for labels, forms and images
    tempXml["id"]=data["id"]
    @categories.each do |category|
      xmlArray=Array.new
      unless (data[category.title]==nil)
       data[category.title].each do |cat|
        unless (cat["name"]==nil)
         cat["content"]=parsed_json[cat["name"]]
         xmlArray<< cat 
         end
        end
       tempXml[category.title]=xmlArray
       end
     end
     
    #Converting tempXml to XML file
    xml_with_data=XmlSimple.xml_out(tempXml,'RootName' =>'form')
    xml_with_data
    saved_xml=File.new(save_path_2,'w')
    saved_xml.write(xml_with_data)
    saved_xml.close
    #@request=Request.new
    #@request.update_attributes(:first_name=>parsed_json["First Name"],:middle_name=>parsed_json["Middle Name"], :last_name=>parsed_json["Last Name"],:address_1=> parsed_json["Address Line 1"],:address_2=>parsed_json["Address Line 2"],:address_3=>parsed_json["Address Line 3"],:languages_known=>languages_known,:profession=>parsed_json["Profession"],:state=>parsed_json["State"],:country=>parsed_json["Country"], :gender=>parsed_json["Gender"], :pincode=>parsed_json["PinCode"])
    #if @request.save
      render :text=> :success
    #else
     # render :text=> :failure
    #end  
  end

  # PUT /requests/1
  # PUT /requests/1.json
  def update
    @request = Request.find(params[:id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to @request, :notice => 'Request was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request = Request.find(params[:id])
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url }
      format.json { head :ok }
    end
  end
end
