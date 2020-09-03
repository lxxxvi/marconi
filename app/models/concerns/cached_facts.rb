module CachedFacts
  extend ActiveSupport::Concern

  included do
    has_many :cached_facts, class_name: "Cached#{self}Fact", dependent: :destroy

    def cached_facts_on_station(station)
      @cached_facts_on_station ||= find_cached_facts_on_station(station)
    end

    def find_cached_facts_on_station(station)
      cached_facts.find_or_initialize_by(station: station)
    rescue ActiveRecord::StatementInvalid => e
      return nil if e.message.starts_with?('PG::UndefinedTable')

      raise e
    end
  end

  class_methods do
    def refresh_cached_facts!
      CachedFactsTableCreator.new(self).create!
    end
  end
end
