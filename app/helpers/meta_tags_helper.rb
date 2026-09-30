module MetaTagsHelper
  SITE_NAME = "Butter & Stars".freeze
  SITE_DESCRIPTION = "Butter & Stars is a personal blog about sports, everyday life and whatever else is worth writing about.".freeze

  # "Post title · Butter & Stars", or just the site name when a page sets no title
  def page_title
    content_for?(:title) ? "#{content_for(:title)} · #{SITE_NAME}" : SITE_NAME
  end

  def meta_description
    content_for?(:description) ? content_for(:description) : SITE_DESCRIPTION
  end

  # The page's URL without query strings, so ?utm_source=... links count as the same page
  def canonical_url
    request.base_url + request.path
  end

  def share_image_url
    content_for?(:share_image) ? content_for(:share_image) : image_url("butter-front_page.jpeg")
  end
end
