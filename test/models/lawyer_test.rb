require "test_helper"

class LawyerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "email del abogado debe tener formato correcto" do
    lawyer = Lawyer.new(email: "test.org", name:"Test",surname:"Testerino")
    assert_not lawyer.save
  end

  test "debe contener nombre y apellido" do
    lawyer = Lawyer.new(email:"test@test.org")
    assert_not lawyer.save
  end
end
