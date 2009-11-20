module RepositoryService
  module TranslationHelper
    def context_name(pk)
      "rsa_#{Digest::MD5.hexdigest(Base64.decode64(pk))}"
    end

    def translate_clause(pk, clause)
      translation = clause.import(context_name(pk))
      translation.delete(" ") unless translation.nil?
    end

    def imported?(clause)
      clause.imported?
    end

  end
end
