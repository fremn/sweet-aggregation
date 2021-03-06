class Aggregation
  attr_reader :pipeline, :model
  def initialize(model_or_criteria)
    @pipeline = []
    if model_or_criteria.is_a?(Mongoid::Criteria)
      @model = model_or_criteria.klass
      match(model_or_criteria.selector)
    elsif model_or_criteria.included_modules.include?(Mongoid::Document)
      @model = model_or_criteria.class
    else
      raise ArgumentError, "must be a criteria or class with Mongoid::Document"
    end
  end

  def method_missing(operator, expression)
    pipeline << { "$#{operator}" => expression }
    self
  end

  def q!
    model.collection.aggregate(pipeline)
  end
end

