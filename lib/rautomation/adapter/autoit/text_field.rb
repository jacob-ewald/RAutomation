module RAutomation
  module Adapter
    module Autoit
      class TextField
        include WaitHelper
        include Locators

        # Default locators used for searching text fields.
        DEFAULT_LOCATORS = {:class => /edit/i}

        # @private
        # Special-cased locators
        LOCATORS = {
                [:class, Regexp] => :regexpclass,
                :index => :instance,
                :value => :text
        }

        # Creates the text field object.
        # @note this method is not meant to be accessed directly, but only through {RAutomation::Window#text_field}!
        # @param [RAutomation::Window] window this text field belongs to.
        # @param [Hash] locators for searching the text field.
        # @option locators [String, Regexp] :class Internal class name of the text field
        # @option locators [String, Regexp] :value Value (text) of the text field
        # @option locators [String, Integer] :id Internal ID of the text field
        # @option locators [String, Integer] :index 0-based index to specify n-th text field if all other criteria match
        # @see RAutomation::Window#text_field
        def initialize(window, locators)
          @window = window
          extract(locators)
        end

        def hwnd
          Window.autoit.ControlGetHandle(@window.locator_hwnd, "", @autoit_locators).hex
        end

        # @see RAutomation::TextField#set
        def set(text)
          wait_until do
            @window.activate
            @window.active? &&
                    Window.autoit.ControlFocus(@window.locator_hwnd, "", @autoit_locators) == 1 &&
                    Window.autoit.ControlSetText(@window.locator_hwnd, "", @autoit_locators, text) == 1 &&
                    value == text
          end
        end

        # @see RAutomation::TextField#clear
        def clear
          set ""
        end

        # @see RAutomation::TextField#value
        def value
          Window.autoit.ControlGetText(@window.locator_hwnd, "", @autoit_locators)
        end

        # @see RAutomation::TextField#exists?
        def exists?
          hwnd != 0
        end

        def hwnd
          handle = Window.autoit.ControlGetHandle(@window.locator_hwnd, "", @autoit_locators)
          handle.to_i(16)
        end
      end
    end
  end
end
