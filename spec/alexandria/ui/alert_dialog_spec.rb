# frozen_string_literal: true

# This file is part of Alexandria.
#
# See the file README.md for authorship and licensing information.

require_relative "../../spec_helper"

describe Alexandria::UI::AlertDialog do
  it "works" do
    parent = Gtk::Window.new :toplevel
    expect do
      described_class.new(parent, "Hello",
                          Gtk::Stock::DIALOG_QUESTION,
                          [[Gtk::Stock::CANCEL, :cancel]], "Hi there")
    end.not_to raise_error
  end
end
