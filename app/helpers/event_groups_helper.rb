module EventGroupsHelper
  def event_group_scoped_link(event_group, scope)
    new_filter  = {:whoops_filter => event_group_filter.to_query_document.merge(scope => event_group.send(scope))}
    link_to(event_group.send(scope), whoops_event_groups_path(new_filter))
  end
  
  # meant for consumption by options_from_collection_for_select
  def filter_options
    all_event_groups = Whoops::EventGroup.all
    return @filter_options if @filter_options

    @filter_options = Hash.new{|h, k| h[k] = []}
    
    @filter_options["service"] = Whoops::EventGroup.services
    
    all_event_groups.each do |event_group|
      mundane_fields = (Whoops::Filter.field_names & Whoops::EventGroup.field_names) - ["service", "message"]
      mundane_fields.each do |field_name|
        @filter_options[field_name] |= [event_group.send(field_name)]
      end
    end

    @filter_options
  end
end
