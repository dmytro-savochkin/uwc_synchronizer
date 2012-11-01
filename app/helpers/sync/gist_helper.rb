module Sync::GistHelper
  def gist_name_for_text_tag(id)
    'gists[' + id + ']'
  end

  def gist_radio_button_name(id)
    gist_name_for_text_tag(id) + '[from]'
  end

  def are_equal?(gist1, gist2)
    return false if gist1.nil?
    return false if gist2.nil?

    ids_equal = gist1[:id] == gist2[:id]
    descriptions_equal = gist1[:description] == gist2[:description]
    files_equal =
        gist1[:files].values.map{|el| [el[:filename], el[:language], el[:contents]]}.sort.to_s.gsub(/\\r/, "") ==
        gist2[:files].values.map{|el| [el[:filename], el[:language], el[:contents]]}.sort.to_s.gsub(/\\r/, "")


    #logger.info "============================"
    #logger.info "============================"
    #logger.info "============================"
    #logger.info gist1[:id]
    #logger.info gist2[:id]
    #logger.info gist1[:description]
    #logger.info gist2[:description]
    #logger.info "============================"

    # a = [{1:1, 2:2}, {3:3, 4:4}]
    # b = [{3:3, 4:4}, {1:1, 2:2}]
    # a.values.sort


    #logger.info gist1[:files].values.to_s.gsub(/\\r/, "")
    #logger.info gist2[:files].values.to_s.gsub(/\\r/, "")
    #logger.info "============================"
    #logger.info gist1[:files].values.map{|el| [el[:filename], el[:language], el[:contents]]}.sort.to_s.gsub(/\\r/, "")
    #logger.info gist2[:files].values.map{|el| [el[:filename], el[:language], el[:contents]]}.sort.to_s.gsub(/\\r/, "")
    #logger.info "============================"
    #logger.info ids_equal
    #logger.info descriptions_equal
    #logger.info files_equal
    #logger.info "============================"
    #logger.info "============================"
    #logger.info "============================"


    ids_equal and descriptions_equal and files_equal
  end

  # [{filename:3, contents:4}, {filename:1, contents:2}] => [{filename:1, contents:2}, {filename:3, contents:4}]
  def sort_gist_files(gist_files)
    gist_files.values.map{|el| [el[:filename], el[:language], el[:contents]]}.sort.map{|el| {:filename => el[0], :language => el[1], :contents => el[2]}}
  end
end
