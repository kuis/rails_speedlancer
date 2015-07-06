# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::MimeTypes
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  IMAGE_EXTENSIONS = %w(jpg jpeg gif png tif svg)
  DOCUMENT_EXTENSIONS = %w(pdf pptx ppt pptx odf odt ods odp doc docx xls xlsx xml html txt zip ai psd)
  AUDIO_EXTENSIONS = %w(mp3 wma ogg wav)
  VIDEO_EXTENSIONS = %w(mp4 mov)


  # Choose what kind of storage to use for this uploader:
  storage :file

  # process :set_content_type , :if => :image?
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  # process :resize_to_fit => [500, 500]
  # Create different versions of your uploaded files:

  version :thumb, :if => :image? do
    
    process :resize_to_fit => [150, 150]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png pdf doc docx txt html)
  # end

  def extension_white_list
    # IMAGE_EXTENSIONS + DOCUMENT_EXTENSIONS + AUDIO_EXTENSIONS + VIDEO_EXTENSIONS
  end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  protected

    def image?(new_file)
      (new_file.content_type.start_with? 'image') and (!(new_file.content_type).include? "photoshop")
    end

end
