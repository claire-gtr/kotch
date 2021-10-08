module ApplicationHelper
  def canonical(url)
    content_for(:canonical, tag(:link, rel: :canonical, href: url)) if url
  end
end
