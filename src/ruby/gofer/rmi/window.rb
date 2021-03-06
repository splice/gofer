#
# Copyright (c) 2011 Red Hat, Inc.
#
# This software is licensed to you under the GNU Lesser General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (LGPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of LGPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/lgpl-2.0.txt.
#
# Jeff Ortel <jortel@redhat.com>
#


class WindowMissed < Exception ; end
  
class WindowPending < Exception ; end


class Window
  
  attr_reader :hash
  
  @@FORMAT = '%Y-%m-%dT%H:%M:%S'
  @@DURATION = {
    :seconds=>1,
    :minutes=>60,
    :hours=>3600,
    :days=>86400,
    :weeks=>604800,
  }
  
  def initialize(window=nil)
    @hash = {}
    if !window.nil?
      @hash.update(window)
      setbegin()
      setend()
    end
  end
  
  private

  def setbegin()
    _BEGIN = :begin
    if @hash.has_key?(_BEGIN)
      v = @hash[_BEGIN]
      if v.nil?
        v = Time.now.utc
      end
      if v.is_a?(Time)
        v = v.strftime(@@FORMAT)
      end
      @hash[_BEGIN] = v
    else
      raise Exception.new('Window() must specify "begin"')
    end
  end

  def setend()
    _END = :end
    if @hash.has_key?(_END)
      v = @hash[_END]
      if v.nil?
        v = Time.now.utc + @@DURATION[:hours]
      end
      if v.is_a?(Time)
        v = v.strftime(@@FORMAT)
      end
      @hash[_END] = v
    else
      if !hasduration()
        raise Exception.new(
          "Window() must have \"end\" or one of: #{@@DURATION.keys}")
      end
    end
  end
  
  def hasduration()
    @@DURATION.keys.each do |k|
      if @hash.has_key?(k)
        return true
      end
    end
    return false
  end
  
end