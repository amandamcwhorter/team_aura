class AppointmentsController < ApplicationController
  require 'active_support/all'
  require 'Date'
  before_filter :authenticate_user!
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :approve, :cancel]
  before_action :set_dropdowns, only: [:new, :create, :update, :edit]

  # GET /appointments
  # GET /appointments.json
  def index
    @appointments = Appointment.where company_id: current_user.company_id
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
    # set company
    @appointment.company_id = current_user.company_id
  end

  # GET /appointments/1/edit
  def edit
  end

  # GET /account/appointments/approve/1
  def approve
    @appointment.accepted = true
    if @appointment.save
      respond_to do |format|
        format.json { render json: @appointment.to_json(:include => [:guest, :host, :location, :service], :methods => [:timestart, :datestart]) }
        format.html { redirect_to :list_account_appointments_path, notice: 'Appointment approved.' }
      end
    end
  end
  # GET /account/appointments/cancel/1
  def cancel
    @appointment.cancelled = true
    if @appointment.save
      respond_to do |format|
        format.json { render json: @appointment.to_json(:include => [:guest, :host, :location, :service], :methods => [:timestart, :datestart]) }
        format.html { redirect_to :list_account_appointments_path, notice: 'Appointment cancelled.' }
      end
    end
  end

  # GET /appointments/book
  def book
    @services_available = Service.where company_id: 2
    @appointment = Appointment.new
    @appointment.company_id = 2
  end

  # POST /appointments
  # POST /appointments.json
  def create
    #convert date string to Datetime object
    @appointment = Appointment.new(appointment_params_parsed)
    @appointment.company_id = current_user.company_id
    @appointment.accepted = false

    # need to ensure there is a User to save as guest
    if !params['newGuest'].nil?
      puts "*****************  New Guest Registration ************** "
      # new guest was created
      @guest = User.new(new_guest_params)

      password_length = 8
      password = Devise.friendly_token.first(password_length)
      @guest.password = password

      user_save_result = @guest.save

      if user_save_result
        #puts "*****************  Save Guest: " + user_save_result.to_s
        # Tell the UserMailer to send a welcome email after save
        UserMailer.welcome_email(@guest,password).deliver
        @appointment.guest_id = @guest.id
      else
        # could not create new user because user exists

      end
    end


    respond_to do |format|
      if @appointment.save


        format.html { redirect_to :list_account_appointments_path, notice: 'Appointment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @appointment }
      else
        format.html { render action: 'new' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /appointments
  # POST /appointments.json
  def booked
    #convert date string to Datetime object
    @appointment = Appointment.new(appointment_params_parsed)
    @appointment.company_id = 2
    @appointment.accepted = false

    # need to ensure there is a User to save as guest
    if !params['newGuest'].nil?
      puts "*****************  New Guest Registration ************** "
      # new guest was created
      @guest = User.new(new_guest_params)

      password_length = 8
      password = Devise.friendly_token.first(password_length)
      @guest.password = password

      user_save_result = @guest.save

      if user_save_result
        #puts "*****************  Save Guest: " + user_save_result.to_s
        # Tell the UserMailer to send a welcome email after save
        UserMailer.welcome_email(@guest,password).deliver
        @appointment.guest_id = @guest.id
      else
        # could not create new user because user exists

      end
    end


    respond_to do |format|
      if @appointment.save


        format.html { redirect_to :list_account_appointments_path, notice: 'Appointment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @appointment }
      else
        format.html { render action: 'new' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update

    respond_to do |format|
      if @appointment.update(appointment_params_parsed)
        format.html { redirect_to :list_account_appointments_path, notice: 'Appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url }
      format.json { head :no_content }
    end
  end

  def unapproved
    @appointments = Appointment.where('company_id = ? AND (accepted is not true) AND (cancelled is not true)', current_user.company_id )
    respond_to do |format|
      format.json { render json: @appointments.to_json(:include => [:guest, :host, :location, :service], :methods => [:timestart, :datestart]) }
      #format.html { render json: @appointments.to_json(:include => [:guest, :host, :location, :service], :methods => [:timestart, :datestart]) }
    end
  end

  def approved
    @appointments = Appointment.where('company_id = ? AND accepted is true AND cancelled is not true', current_user.company_id )
    respond_to do |format|
      format.json { render json: @appointments.to_json(:include => [:guest, :host, :location, :service], :methods => [:timestart, :datestart]) }
      #format.html { render json: @appointments.to_json(:include => [:guest, :host, :location, :service], :methods => [:timestart, :datestart]) }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params[:appointment].permit(:host_id, :service_id, :datetime_begin, :cost, :notification_on, :location_id, :guest_id )
    end

    def appointment_params_parsed
      @these_params = appointment_params
      if !@these_params['datetime_begin'].blank?
        puts "********************** DATE " + @these_params['datetime_begin'].to_s
        appointment_date = DateTime.strptime(@these_params['datetime_begin'], '%m/%d/%Y %H:%M')
        @these_params['datetime_begin'] = appointment_date
      end
      return @these_params
    end


    def new_guest_params
      params[:user].permit(:email, :first_name, :last_name )
    end

    def set_dropdowns
      # get all locations for this company
      # used for dropdowns on appt form
      @locations = {}
      if !current_user.company.locations.nil?
        current_user.company.locations.each do |location|
          @locations[location.citystate] = location.id
        end
      end

      # past clients who are registered in the system
      @guests = {}
      if !current_user.company.appointments.nil?
        current_user.company.appointments.select(:guest_id).distinct.each do |appt|
          if !appt.guest_id.nil?
            display_name = appt.guest.fullname
            if !appt.guest.email.nil?
              display_name += " ("+appt.guest.email+")"
            end
            @guests[display_name] = appt.guest.id
          end

        end
      end

      @newGuest = User.new
      @newGuest.role_id = Role::ROLE_REGISTERED
      # current staff list
      @staff = {}
      if !current_user.company.users.nil?
        current_user.company.users.each do |user|
          @staff[user.fullname] = user.id
        end
      end

      # current staff list
      @services = {}
      if !current_user.company.services.nil?
        @services = current_user.company.services
      end
    end
end
