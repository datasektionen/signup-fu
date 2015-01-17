# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'net/smtp'

describe User do
  context 'name' do
    subject { User.new(:email => 'patrik.stenmark@gmail.com', :password => 'kaka123') } 

    before(:each) do
      subject.name = 'patrik'
    end

    it "allows lowercase" do
      expect(subject).to be_valid
    end

    it "allows hyphens" do
      subject.name += "-"
      expect(subject).to be_valid
    end

    it "allows numbers" do
      subject.name += "0"
      expect(subject).to be_valid
    end

    it "disallows capital letters" do
      subject.name += "A"
      expect(subject).to be_invalid
    end

    it "disallows initial hyphen" do
      subject.name = "-" + subject.name
      expect(subject).to be_invalid
    end

    it "disallows initial digit" do
      subject.name = "0" + subject.name
      expect(subject).to be_invalid
    end
  end
end
