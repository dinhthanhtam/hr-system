require 'csv'
class MasterImporter
  def initialize
    @model = nil
    @with_id = false
  end

  def run
    Dir.glob( Rails.root.to_s + '/db/masters/**/*.{yml,csv}' ).sort.each { |master|
      send( "import_#{File.extname( master )[1..master.bytesize]}_master", master )
    }
  end

  def fcsv_opts
    { :headers => true,
      :header_converters => :downcase }
  end

  def import_csv_master( file )
    puts "Importing file: `#{file}' ..."
    init_model( file, '.csv' )
    @with_id = CSV.table( file, fcsv_opts ).headers.include?( 'id' )
    @model.delete_all
    if ( @with_id )
      _import_csv( file ) { |row| create_and_save_with_id( row.to_hash ) }
    else
      _import_csv( file ) { |row| create_and_save( row.to_hash ) }
    end
  end

  def _import_csv( file, &block )
    CSV.open( file, fcsv_opts ).each { |csv| block.call( csv ) }
  end

  def import_yml_master( file )
    init_model( file, '.yml' )
    YAML.load_file( file ).each { |master|
      if ( r.has_key?( 'id' ) )
        create_and_save_with_id( master )
      else
        create_and_save( master )
      end
    }
  end

  def to_model( file, suffix )
    File.basename( file, suffix ).sub( /\A[0-9]+(_\.)?/, '' ).classify
  end

  def init_model( file, suffix )
    @model = Object.const_get( to_model( file, suffix ) )
  end

  def create_and_save( data )
    @model.create!( data, validate: false )
  end

  def create_and_save_with_id( data )
    record = @model.new( data )
    record['id'] = data['id']
    record.save!(validate: false)
  end
end
