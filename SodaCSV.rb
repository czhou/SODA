###############################################################################
# Copyright (c) 2010, SugarCRM, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of SugarCRM, Inc. nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL SugarCRM, Inc. BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

###############################################################################
# Needed Ruby Libs:
###############################################################################
require "csv"

###############################################################################
# SodaCSV -- Class
#     This class parses CSV files and converts them into records that can be 
#     accessed as variables in Soda XML scripts.  The first ROW of CSV file is
#     the variable names to be used Then each subsequent ROW is data.
#
# Params:
#     file: This the csv file.
#
# Results:
#     None.
#
###############################################################################
class SodaCSV
   attr_accessor :fieldMap, :csvdata
   
   def initialize(file)
      @csvdata = CSV.open(file, 'r')
      @fieldMap = @csvdata.shift
           len = @fieldMap.length() -1

      # this is to deal with badly writen CSV files #
      for i in 0..len do
         if (@fieldMap[i] == nil)
            @fieldMap[i] = ""
         end
      end
   end
   
###############################################################################
# nextRecord -- Method 
#     This method pulls the next record from the CSV and returns it as a hash.
#
# Params:
#     None.
#
# Results:
#     returns a filled hash on success, or nil on error or no data.
#
###############################################################################
   def nextRecord()
      record = {}
      data = @csvdata.shift
      all_nil = true

      if (!data.empty?)
         @fieldMap.each_index do|k|
            if (!data[k].to_s.empty?)
               all_nil = false
            end

            if (data[k] != nil)
               data[k] = data[k].gsub('\n', "\n")
            else
               data[k] = ""
            end

            record[@fieldMap[k]] = data[k]
         end
      else 
         record = nil
      end

      if ( (all_nil != false) || (record == nil) )
         record = nil
      end

      return record
   end
end

