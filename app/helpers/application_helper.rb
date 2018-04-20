module ApplicationHelper
  BOOTSTRAP_FLASH_KEYS = { success: 'alert-success',
                           error:   'alert-danger',
                           danger:  'alert-danger',
                           alert:   'alert-warning',
                           notice:  'alert-info'
  }.freeze

  def bootstrap_class_for flash_type
    BOOTSTRAP_FLASH_KEYS[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      unless !message
        concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
          concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
          concat message
        end)
      end
    end
    nil
  end

  def menu_item(name, link, avatar)
    img = image_tag avatar, class: 'main-menu-icon'
    content_tag :li, class: current_page?(link) ? 'active' : '' do
      content_tag :a, href: link do
        img + name
      end
    end
  end

  def link_to_sort(sort)
    class_name = 'glyphicon-title glyphicon'
    if sort.to_sym == session.try(:[], controller_name).try(:[], 'sort').try(:to_sym)
      if session.try(:[], controller_name).try(:[], 'index') == 'asc'
        class_name += ' glyphicon-sort-by-attributes'
      else
        class_name += ' glyphicon-sort-by-attributes-alt'
      end
    else
      class_name += ' glyphicon-sort'
    end
    content_tag :a, '', class: class_name, href: "#{controller_name}?sort=#{sort}", :'data-remote' => true
  end
end
