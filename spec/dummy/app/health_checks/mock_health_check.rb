class MockHealthCheck < Health::Check
  health_check :example,
               frequency: 1.day

  health_check :another_example,
               frequency: 1.hour

  health_check :yet_another_example,
               frequency: 1.hour

  health_check :last_example,
               scheduled: :mondays

  private

  def example
    []
  end

  def another_example
    []
  end

  def yet_another_example
    []
  end

  def last_example
    []
  end
end