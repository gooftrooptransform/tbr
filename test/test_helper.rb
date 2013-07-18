require 'minitest/autorun'
require'fileutils'
 
require_relative '../app/helper'

class TestHelper < MiniTest::Test 
  
  def setup
    @helper = Helper.new
  end
  
  def test_correct_directory_structure
    assert(@helper.check_directory_structure)   
  end
  
  def test_wrong_directory_structure
    Dir.chdir('./test')
    refute(@helper.check_directory_structure)
    Dir.chdir('../')
  end
  
  def test_fix_directory_structure
    FileUtils.rm_rf('./tmp')
    Dir.mkdir('./tmp')
    Dir.chdir('./tmp')
    @helper.fix_directory_structure
    assert(@helper.check_directory_structure)
    Dir.chdir('../')
    FileUtils.rm_rf('./tmp')
  end
  
  def test_base_directory
    ENV["OCRA_EXECUTABLE"] = '/tmp/tbr.exe'
    assert_equal('/tmp',@helper.base_directory)
    ENV["OCRA_EXECUTABLE"] = ''
    assert_equal(Dir.pwd,@helper.base_directory)
    ENV["OCRA_EXECUTABLE"] = nil
    assert_equal(Dir.pwd,@helper.base_directory)
  end
  
  def test_config_path
    ENV["OCRA_EXECUTABLE"] = '/tmp/tbr.exe'
    assert_equal('/tmp/config/services.csv',@helper.config_path)
  end
  
  def test_bill_path
    root = "#{Dir.pwd}/test"
    ENV["OCRA_EXECUTABLE"] = "#{root}/tbr.exe"
    assert_equal("#{root}/data/latest.csv",@helper.bill_path)
  end
end
