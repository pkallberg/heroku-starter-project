module MarkdownHandler

  def self.erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end


  def self.call(template)
    compiled_source = erb.call(template)
    "markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true);markdown.render(begin;#{compiled_source};end)"
  end
end

ActionView::Template.register_template_handler :md, MarkdownHandler
