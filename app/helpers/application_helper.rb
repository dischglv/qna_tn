module ApplicationHelper
  def gist?(url)
    url.include?('https://gist.github.com/')
  end
end
