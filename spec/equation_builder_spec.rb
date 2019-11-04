require 'spec_helper'

require 'equation_builder'

describe EquationBuilder do
  context 'simple equations' do
    context 'with + operator' do
      subject { EquationBuilder.new([2, 4], 6, '+').solve }
      it { should == '2+4' }
    end

    context 'with - operator' do
      subject { EquationBuilder.new([2, 4], -2, '-').solve }
      it { should == '2-4' }
    end

    context 'with multiple operators' do
      subject { EquationBuilder.new([2, 4, 6], 4, %w(- +)).solve }
      it { should == '2-4+6' }
    end

    context 'with repeating operator' do
      subject { EquationBuilder.new([2, 4, 6], 12, '+').solve }
      it { should == '2+4+6' }
    end

    context 'with multiple repeating operators' do
      subject { EquationBuilder.new([2, 4, 6, 8], 0, %w(+ -)).solve }
      it { should == '2-4-6+8' }
    end
  end

  context 'with long equation' do
    subject { EquationBuilder.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 0, %w(* -)).solve }
    it { should == '1*2*3*4*5-6*9-7*8-10' }
  end

  context 'with float numbers' do
    subject { EquationBuilder.new([1, 2], 0.5, %w(/ *)).solve }
    it { should == '1/2' }
  end

  context 'with parentheses' do
    context 'with single parentheses' do
      subject { EquationBuilder.new([1, 2, 4, 5], 17, %w(+ *)).solve }
      it { should == '(1+2)*4+5' }
    end

    context 'with double parentheses' do
      subject { EquationBuilder.new([5, 5, 5, 5], 100, %w(+ *)).solve }
      it { should == '(5+5)*(5+5)' }
    end
  end

  context 'ultimate example' do
    subject { EquationBuilder.new([1, 3, 4, 6], 24, %w(- /)).solve }
    it { should == '6/(1-3/4)' }
  end

  context 'equation not found' do
    subject { EquationBuilder.new([1, 2], 4, '+').solve }
    it { should be_nil }
  end
  
  context 'with exponents' do
    subject { EquationBuilder.new([3, 2, 3], 243, ['+', '**']).solve }
    it { should == '3**(2+3)' }
  end
end
