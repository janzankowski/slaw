# encoding: UTF-8

require 'spec_helper'
require 'slaw'

describe Slaw::ActGenerator do
  describe 'guess_section_number_after_title' do
    context 'section number after title' do
      it 'should work' do
        text = "
Section title
1. Section content

Another section title
2. Section content that is long.
"
        subject.guess_section_number_after_title(text).should be_true
      end
    end

    context 'section number before title' do
      it 'should default to false' do
        subject.guess_section_number_after_title("").should be_false
      end

      it 'should be false' do
        text = "
Mistaken title
1. Section title

Some content.

2. Second title

Some content.
"
        subject.guess_section_number_after_title(text).should be_false
      end
    end
  end

  describe 'unparse' do
    it 'should escape keywards when unparsing' do
      doc = xml2doc(section(<<XML
        <num>1.</num>
        <heading>Section</heading>
        <paragraph id="section-1.paragraph-0">
          <content>
            <p>Chapter 2 ignored</p>
            <p>Part 2 ignored</p>
            <p>Schedule 2 ignored</p>
            <p>BODY ignored</p>
            <p>PREAMBLE ignored</p>
            <p>PREFACE ignored</p>
            <p>2. ignored</p>
            <p>2.1 ignored</p>
            <p>(2) ignored</p>
            <p>(a) ignored</p>
            <p>(2a) ignored</p>
            <p>{| ignored</p>
          </content>
        </paragraph>
XML
      ))

      text = subject.text_from_act(doc)
      text.should == '1. Section

\Chapter 2 ignored

\Part 2 ignored

\Schedule 2 ignored

\BODY ignored

\PREAMBLE ignored

\PREFACE ignored

\2. ignored

\2.1 ignored

\(2) ignored

\(a) ignored

\(2a) ignored

\{| ignored

'
    end
  end
end
