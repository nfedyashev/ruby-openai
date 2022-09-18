module OpenAI
  class Client
    include HTTParty
    base_uri "https://api.openai.com"

    def initialize(access_token: nil)
      @access_token = access_token || ENV.fetch("OPENAI_ACCESS_TOKEN")
    end

    def answers(version: default_version, parameters: {})
      post(url: "/#{version}/answers", parameters: parameters)
    end

    def classifications(version: default_version, parameters: {})
      post(url: "/#{version}/classifications", parameters: parameters)
    end

    def completions(version: default_version, parameters: {})
      post(url: "/#{version}/completions", parameters: parameters)
    end

    def edits(version: default_version, parameters: {})
      post(url: "/#{version}/edits", parameters: parameters)
    end

    def embeddings(version: default_version, parameters: {})
      post(url: "/#{version}/embeddings", parameters: parameters)
    end

    def files
      @files ||= OpenAI::Files.new(access_token: @access_token)
    end

    def finetunes
      @finetunes ||= OpenAI::Finetunes.new(access_token: @access_token)
    end

    def models
      @models ||= OpenAI::Models.new(access_token: @access_token)
    end

    def moderations(version: default_version, parameters: {})
      post(url: "/#{version}/moderations", parameters: parameters)
    end

    private

    def default_version
      "v1".freeze
    end

    def documents_or_file(documents: nil, file: nil)
      documents ? { documents: documents } : { file: file }
    end

    def post(url:, parameters:)
      self.class.post(
        url,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{@access_token}"
        },
        body: parameters.to_json
      )
    end
  end
end
