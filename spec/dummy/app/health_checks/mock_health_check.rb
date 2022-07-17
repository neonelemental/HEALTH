class MockHealthCheck < Health::Check
  health_check :example,
               frequency: 1.day

  health_check :another_example,
               frequency: 1.hour

  health_check :yet_another_example,
               frequency: 1.hour

  private

  def example
  end

  def another_example
  end

  def yet_another_example
  end
end