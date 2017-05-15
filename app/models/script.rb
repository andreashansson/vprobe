class Script < ActiveRecord::Base

  has_many :scriptconfigs
  has_many :testconfigs, through: :scriptconfigs
  accepts_nested_attributes_for :testconfigs, :scriptconfigs
  validates :name, :presence => true
  validates :body, :presence => true
  validate :check_format
  attr_accessor :file



  #def assign_file_contents(script_params)
  #    file = script_params[:file]
  #    #check_format(file.original_filename)
  #    #debugger
  #    @name = file.original_filename
  #    @body = file.read
  #    @body = @body.gsub(/\r\n?/,"\n")
  #    new(name: @name, body: @body)
  #end


  private
  def check_format
    accepted_formats = [".sh", ".py"]
    errors.add(:file, "You may only upload .sh or .py files!") and return false unless accepted_formats.include? File.extname(name)
  end
end
