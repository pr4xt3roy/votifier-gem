require 'test/unit'
require 'votifier'

class VotifierKeyTest < Test::Unit::TestCase

  def test_import_public_pem_filename
    public_pem_file_name = File.expand_path('../../config/sample-public.pem', __FILE__)
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(public_pem_file_name)
    end
    assert !key.nil?
  end

  def test_import_private_pem_filename
    private_pem_file_name = File.expand_path('../../config/sample-private.pem', __FILE__)
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(private_pem_file_name)
    end
    assert !key.nil?
  end

  def test_import_public_pem_file_object
    public_pem_file_name = File.expand_path('../../config/sample-public.pem', __FILE__)
    public_pem_file_obj = File.open(public_pem_file_name, 'r')
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(public_pem_file_obj)
    end
    assert !key.nil?
  end

  def test_import_private_pem_file_object
    private_pem_file_name = File.expand_path('../../config/sample-private.pem', __FILE__)
    private_pem_file_obj = File.open(private_pem_file_name, 'r')
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(private_pem_file_obj)
    end
    assert !key.nil?
  end

  def test_import_public_pem_string
    public_pem_file_name = File.expand_path('../../config/sample-public.pem', __FILE__)
    public_pem_file_string = File.open(public_pem_file_name, 'r').read
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(public_pem_file_string)
    end
    assert !key.nil?
  end

  def test_import_private_pem_string
    private_pem_file_name = File.expand_path('../../config/sample-private.pem', __FILE__)
    private_pem_file_string = File.open(private_pem_file_name, 'r')
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(private_pem_file_string)
    end
    assert !key.nil?
  end

  def test_import_public_non_pem_filename
    public_non_pem_file_name = File.expand_path('../../config/sample-public.key', __FILE__)
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(public_non_pem_file_name)
    end
    assert !key.nil?
  end

  def test_import_private_non_pem_filename
    private_non_pem_file_name = File.expand_path('../../config/sample-private.key', __FILE__)
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(private_non_pem_file_name)
    end
    assert !key.nil?
  end

  def test_import_public_non_pem_file_object
    public_non_pem_file_name = File.expand_path('../../config/sample-public.key', __FILE__)
    public_non_pem_file_obj = File.open(public_non_pem_file_name, 'r')
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(public_non_pem_file_obj)
    end
    assert !key.nil?
  end

  def test_import_private_non_pem_file_object
    private_non_pem_file_name = File.expand_path('../../config/sample-private.key', __FILE__)
    private_non_pem_file_obj = File.open(private_non_pem_file_name, 'r')
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(private_non_pem_file_obj)
    end
    assert !key.nil?
  end

  def test_import_public_non_pem_string
    public_non_pem_file_name = File.expand_path('../../config/sample-public.key', __FILE__)
    public_non_pem_file_string = File.open(public_non_pem_file_name, 'r').read
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(public_non_pem_file_string)
    end
    assert !key.nil?
  end

  def test_import_private_non_pem_string
    private_non_pem_file_name = File.expand_path('../../config/sample-private.key', __FILE__)
    private_non_pem_file_string = File.open(private_non_pem_file_name, 'r')
    key = nil
    assert_nothing_raised do
      key = Votifier::Key.import(private_non_pem_file_string)
    end
    assert !key.nil?
  end

end
