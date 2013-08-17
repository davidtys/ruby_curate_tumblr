require 'spec_helper'

describe CurateTumblr::Curator do 

  describe "config" do
    it "get hash" do
      oauth_consumer_key = RandomWord.nouns.next
      oauth_consumer_secret = RandomWord.nouns.next
      oauth_token = RandomWord.nouns.next
      oauth_token_secret = RandomWord.nouns.next
      infos_name = RandomWord.nouns.next
      hash_config = {}
        hash_config.merge!( CurateTumblr::Tumblr::Client::get_client_config_hash( oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret ) )
        hash_config.merge!( CurateTumblr::Tumblr::Infos::get_infos_config_hash )
      expect { CurateTumblr::Curator.check_config_hash( hash_config ) }.to_not raise_error
    end

    it "empty" do
      expect { CurateTumblr::Curator.check_config_hash( { 
        CurateTumblr::Tumblr::Client::HASH_CONFIG_CLIENT => {},
        CurateTumblr::Tumblr::Infos::HASH_CONFIG_INFOS => {},
      } ) }.to raise_error
    end

    it "get document yaml" do
      string_yaml = CurateTumblr::Curator.get_string_yaml_from_config( get_random_config_hash )
      string_yaml.should be_true
      string_yaml.empty?.should_not be_true
      documents = YAML::load_documents( string_yaml )
      documents.is_a?( Array ).should be_true
      documents.count.should eq( 1 )
      hash_config = documents.first
      expect { CurateTumblr::Curator.check_config_hash( hash_config ) }.to_not raise_error
    end
  end
end  