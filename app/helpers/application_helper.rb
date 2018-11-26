module ApplicationHelper
  FLASH_TO_CSS_CLASS = {
    notice:  "alert alert-info",
    success: "alert alert-success",
    alert:   "alert alert-warning",
    error:   "alert alert-danger"
  }.freeze

  def flash_css_class(level)
    FLASH_TO_CSS_CLASS[level.to_sym]
  end
end
