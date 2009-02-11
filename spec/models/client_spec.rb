require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Client do

  before(:each) do
    @manager = StaffMember.new(:name => "Mrs. M.A. Nerger")
    @manager.should be_valid

    @branch = Branch.new(:name => "Kerela branch")
    @branch.manager = @manager
    @branch.should be_valid

    @center = Center.new(:name => "Munnar hill center")
    @center.manager = @manager
    @center.branch = @branch
    @center.should be_valid

    @client = Client.new(:name => 'Ms C.L. Ient', :reference => 'XW000-2009.01.05')
    @client.center  = @center
    @client.should be_valid
  end
 
  it "should not be valid without belonging to a center" do
    @client.center = nil
    @client.should_not be_valid
  end
 
  it "should not be valid without a name" do
    @client.name = nil
    @client.should_not be_valid
  end
  
  it "should not be valid without a reference" do
    @client.reference = nil
    @client.should_not be_valid
  end

  it "should not be valid with name shorter than 3 characters" do
    @client.name = "ok"
    @client.should_not be_valid
  end
 
  it "should be able to 'have' loans" do
    @loan = Loan.new(:amount => 1000, :interest_rate => 0.2, :installment_frequency => :weekly, :number_of_installments => 30, :scheduled_first_payment_date => "2000-12-06", :approved_on => "2000-02-03", :scheduled_disbursal_date => "2000-06-13")
    @loan.approved_by = @manager
    @loan.client      = @client
    @loan.should be_valid

    @client.loans << @loan
    @client.should be_valid
    @client.loans.first.amount.should eql(1000)
    @client.loans.first.installment_frequency.should eql(:weekly)


    loan2 = Loan.new(:amount => 10000, :interest_rate => 0.2, :installment_frequency => :weekly, :number_of_installments => 30, :scheduled_first_payment_date => "2000-12-07", :approved_on => "2000-02-04", :scheduled_disbursal_date => "2000-06-14")
    loan2.approved_by = @manager
    loan2.client      = @client
    loan2.should be_valid

    @client.loans << loan2
    @client.should be_valid
    @client.loans.size.should eql(2)
  end

end