# Copyright (C) 2004 Laurent Sansonetti
#
# Alexandria is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# Alexandria is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with Alexandria; see the file COPYING.  If not,
# write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

module Alexandria
module UI
    class InfoBookDialog < GladeBase
        def initialize(parent, library, book)
            super('info_book_dialog.glade')
            @info_book_dialog.transient_for = parent
            @image_cover.file = library.medium_cover(book)
            @label_title.text = @info_book_dialog.title = book.title
            @label_authors.text = book.authors.join("\n")
            @label_isbn.text = book.isbn
            @label_publisher.text = book.publisher
            @label_edition.text = book.edition
            buffer = Gtk::TextBuffer.new
            buffer.text = (book.notes or "")
            @textview_notes.buffer = buffer
            @library, @book = library, book
            self.rating = (book.rating or 3)
        end

        def on_image_rating1_press
            self.rating = 1
        end
        
        def on_image_rating2_press
            self.rating = 2 
        end
        
        def on_image_rating3_press
            self.rating = 3 
        end
        
        def on_image_rating4_press
            self.rating = 4 
        end
        
        def on_image_rating5_press
            self.rating = 5 
        end
        
        def on_close
            new_notes = @textview_notes.buffer.text
            new_rating = @current_rating 
            need_save = false
    
            # Notes have changed.
            if @book.notes.nil? or (new_notes != @book.notes)
                @book.notes = new_notes
                need_save = true
            end
            
            # Rating has changed.
            if @book.rating.nil? or (new_rating != @book.rating)
                @book.rating = new_rating
                need_save = true
            end

            @library.save(@book) if need_save
            @info_book_dialog.destroy
        end

        #######
        private
        #######
    
        def rating=(rating)
            images = [ 
                @image_rating1, 
                @image_rating2, 
                @image_rating3, 
                @image_rating4, 
                @image_rating5
            ]
            raise "out of range" if rating < 0 or rating > images.length
            images[0..rating-1].each { |x| x.pixbuf = Icons::STAR_OK }
            images[rating..-1].each { |x| x.pixbuf = Icons::STAR_NOK }
            @current_rating = rating 
        end
    end
end
end
