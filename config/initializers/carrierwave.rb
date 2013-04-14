CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider => "AWS",
      :aws_access_key_id => CONFIG[:AWS_ACCESS_KEY_ID],
      :aws_secret_access_key => CONFIG[:AWS_SECRET_ACCESS_KEY],
      :region => CONFIG[:AWS_S3_REGION]
    }
    if Rails.env.production?
      config.fog_directory = CONFIG[:AWS_S3_BUCKET]  
    else
      config.fog_directory = CONFIG[:AWS_S3_BUCKET_TEST]
    end
end