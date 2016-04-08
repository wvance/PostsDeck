module ContentsHelper
  def convert_provider(providers)
    providers.each do |provider|
      raise provider.inspect
    end
  end
end
