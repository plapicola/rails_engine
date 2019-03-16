class BestDaySerializer
  include FastJsonapi::ObjectSerializer
  attribute :best_day do |resource|
    resource.best_day.strftime("%F")
  end
end
