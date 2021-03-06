require 'minitest/autorun'
require'fileutils'
require 'gtk2'
 
require_relative '../app/log_it'

class TestLogIt < MiniTest::Test 
  def setup
  	@log = LogIt.instance
  end

	def teardown
		@log.to_null
	end
	
	def test_singleton
		a = LogIt.instance
		b = LogIt.instance
		assert_equal(a,b)
	end

  def test_to_stdout
    if @@test_dialogs
      puts ''
      @log.to_stdout
      @log.warn("STDOUT - Hello World")
    end
  end
  
  def test_to_stderr
    if @@test_dialogs
      puts ''
      @log.to_stderr
      @log.warn("STDERR - Hello World")
    end
  end  
	
	def test_to_file
		fname = './test/test.log'
		FileUtils.rm_rf(fname)
		@log.to_file(fname)
		@log.warn("Hello World")
		@log.close
		
		assert(File.size(fname) > 0)
    FileUtils.rm_rf(fname)
	end	
  
  def test_testview
    textview = Gtk::TextView.new
    
    # Needed to stop GtkTextLayout error
    scrolledw = Gtk::ScrolledWindow.new
    scrolledw.add(textview)
    
    @log.textview = textview
    test_to_file
    assert_equal("Warning - Hello World\n",textview.buffer.text)
  end
end
