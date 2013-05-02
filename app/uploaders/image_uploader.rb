# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  include CarrierWave::Backgrounder::Delay
    
  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

        
  process :set_content_type
  
  # Override the directory where uploaded files will be stored.
  #     This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  #   #    
  def cache_dir       
    "uploads/tmp/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  # Create different versions of your uploaded files:
    version :thumb do
     process :resize_to_limit => [300, 300]
    end

    version :passport do
     process :resize_to_limit => [100, 100]
    end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
