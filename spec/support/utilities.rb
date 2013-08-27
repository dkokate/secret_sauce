
include ApplicationHelper

# With above include, full_title helper in Utilities is redundant 
# full_title of ApplicationHelper has been tested
# def full_title(page_title)
#   base_title = "Secret Sauce"
#   if page_title.empty?
#     base_title
#   else
#     "#{base_title} | #{page_title}"
#   end
# end