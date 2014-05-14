class User < ActiveRecord::Base
  belongs_to :company
  accepts_nested_attributes_for :company
  belongs_to :role
  has_many :appointments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  COLORS = ["blue","green","red","black","pink","purple","orange"]

  def fullname
    @fullname = '' #start with a blank to avoid nil problems in the view
    if !self.first_name.nil?
      # if first name, append it
      @fullname += self.first_name
      if @fullname.length && !self.last_name.nil? && self.last_name.length
        # if there's also a last name, make a space for it
        @fullname += ' '
      end
    end

    if !self.last_name.nil?
      @fullname += self.last_name
    end

    return @fullname
  end

  # pick next color for employee for calendar display
  def self.pickColor(company_id)
    @num_users = User.where(company_id: company_id).count
    @colors_length = User::COLORS.length

    #puts "*********************** " + @num_users.to_s
    #puts "*********************** " + @colors_length.to_s
    if(@num_users < @colors_length)
      @pick = @num_users
    else
      @pick = @num_users%@colors_length
    end

    #puts "*********************** get the " + @pick.to_s + "th element: " + COLORS[@pick]

    return COLORS[@pick]

  end
end
