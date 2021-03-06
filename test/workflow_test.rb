require 'minitest/autorun'
require 'alfred-3_workflow'

class TestWorkflow < MiniTest::Test
  def setup
    @workflow = Alfred3::Workflow.new
  end

  def test_that_it_can_add_a_result
    @workflow.result.uid('THE ID')
                    .title('Item Title')
                    .subtitle('Item Subtitle')
                    .quicklookurl('https://www.google.com')
                    .type('file')
                    .arg('ARGUMENT')
                    .valid(false)
                    .icon('icon.png')
                    .mod('cmd', 'Do Something Different', 'something-different')
                    .mod('shift', 'Another Different', 'another-different', false)
                    .copy('Please copy this')
                    .largetype('This will be huge')
                    .autocomplete('AutoComplete This')

    expected = {
        'items' => [
            {
                'arg'          => 'ARGUMENT',
                'autocomplete' => 'AutoComplete This',
                'icon'         => {
                    'path' => 'icon.png'
                },
                'mods' => {
                    'cmd' => {
                        'subtitle' => 'Do Something Different',
                        'arg'      => 'something-different',
                        'valid'    => true
                    },
                    'shift' => {
                        'subtitle' => 'Another Different',
                        'arg'      => 'another-different',
                        'valid'    => false
                    },
                },
                'quicklookurl' => 'https://www.google.com',
                'subtitle'     => 'Item Subtitle',
                'text'         => {
                    'copy'      => 'Please copy this',
                    'largetype' => 'This will be huge'
                },
                'title'        => 'Item Title',
                'type'         => 'file',
                'uid'          => 'THE ID',
                'valid'        => false
            }
        ]
    }

    assert_equal expected.to_json, @workflow.output
  end

  def test_that_it_can_add_multiple_results
    @workflow.result
                .uid('THE ID')
                .title('Item Title')
                .subtitle('Item Subtitle')
                .quicklookurl('https://www.google.com')
                .type('file')
                .arg('ARGUMENT')
                .valid(false)
                .icon('icon.png')
                .mod('cmd', 'Do Something Different', 'something-different')
                .mod('shift', 'Another Different', 'another-different', false)
                .copy('Please copy this')
                .largetype('This will be huge')
                .autocomplete('AutoComplete This')

    @workflow.result
                .uid('THE ID 2')
                .title('Item Title 2')
                .subtitle('Item Subtitle 2')
                .quicklookurl('https://www.google.com/2')
                .type('file')
                .arg('ARGUMENT 2')
                .valid(true)
                .icon('icon2.png')
                .mod('cmd', 'Do Something Different 2', 'something-different 2')
                .mod('shift', 'Another Different 2', 'another-different 2', false)
                .copy('Please copy this 2')
                .largetype('This will be huge 2')
                .autocomplete('AutoComplete This 2')

    expected = {
        'items' => [
            {
                'arg'          => 'ARGUMENT',
                'autocomplete' => 'AutoComplete This',
                'icon'         => {
                    'path' => 'icon.png'
                },
                'mods' => {
                    'cmd' => {
                        'subtitle' => 'Do Something Different',
                        'arg'      => 'something-different',
                        'valid'    => true
                    },
                    'shift' => {
                        'subtitle' => 'Another Different',
                        'arg'      => 'another-different',
                        'valid'    => false
                    },
                },
                'quicklookurl' => 'https://www.google.com',
                'subtitle'     => 'Item Subtitle',
                'text'         => {
                    'copy'      => 'Please copy this',
                    'largetype' => 'This will be huge'
                },
                'title'        => 'Item Title',
                'type'         => 'file',
                'uid'          => 'THE ID',
                'valid'        => false
            },
            {
                'arg'          => 'ARGUMENT 2',
                'autocomplete' => 'AutoComplete This 2',
                'icon'         => {
                    'path' => 'icon2.png'
                },
                'mods' => {
                    'cmd' => {
                        'subtitle' => 'Do Something Different 2',
                        'arg'      => 'something-different 2',
                        'valid'    => true
                    },
                    'shift' => {
                        'subtitle' => 'Another Different 2',
                        'arg'      => 'another-different 2',
                        'valid'    => false
                    },
                },
                'quicklookurl' => 'https://www.google.com/2',
                'subtitle'     => 'Item Subtitle 2',
                'text'         => {
                    'copy'      => 'Please copy this 2',
                    'largetype' => 'This will be huge 2'
                },
                'title'        => 'Item Title 2',
                'type'         => 'file',
                'uid'          => 'THE ID 2',
                'valid'        => true
            }
        ]
    }

    assert_equal expected.to_json, @workflow.output
  end

  def test_that_it_can_handle_a_file_skipcheck_via_arguments
    @workflow.result.type('file', false)

    expected = {
      'items' => [
        {
          'type'  => 'file:skipcheck',
          'valid' => true,
        }
      ]
    }

    assert_equal expected.to_json, @workflow.output
  end

  def test_that_it_can_add_mods_via_shortcuts
    @workflow.result.cmd('Hit Command', 'command-it', false)
                    .shift('Hit Shift', 'shift-it', true)

    expected = {
      'items' => [
        {
          'mods' => {
              'cmd' => {
                  'subtitle' => 'Hit Command',
                  'arg'      => 'command-it',
                  'valid'    => false,
              },
              'shift' => {
                  'subtitle' => 'Hit Shift',
                  'arg'      => 'shift-it',
                  'valid'    => true,
              },
          },
          'valid' => true,
        }
      ]
    }

    assert_equal expected.to_json, @workflow.output
  end

  def test_that_it_can_handle_file_icon_via_shortcut
    @workflow.result.fileicon_icon('icon.png');

    expected = {
      'items' => [
        {
          'icon' => {
              'path' => 'icon.png',
              'type' => 'fileicon',
          },
          'valid' => true,
        }
      ]
    }

    assert_equal expected.to_json, @workflow.output
  end

  def test_that_it_can_sort_results_by_defaults
    @workflow.result
                .uid('THE ID 2')
                .title('Item Title 2')
                .subtitle('Item Subtitle 2')

    @workflow.result
                .uid('THE ID')
                .title('Item Title')
                .subtitle('Item Subtitle')

    expected = {
      'items' => [
        {
            'subtitle'     => 'Item Subtitle',
            'title'        => 'Item Title',
            'uid'          => 'THE ID',
            'valid'        => true,
        },
        {
            'subtitle'     => 'Item Subtitle 2',
            'title'        => 'Item Title 2',
            'uid'          => 'THE ID 2',
            'valid'        => true,
        }
      ]
    }

    assert_equal expected.to_json, @workflow.sort_results.output
  end

  def test_that_it_can_sort_results_desc
    @workflow.result
                .uid('THE ID')
                .title('Item Title')
                .subtitle('Item Subtitle')

    @workflow.result
                .uid('THE ID 2')
                .title('Item Title 2')
                .subtitle('Item Subtitle 2')

    expected = {
      'items' => [
        {
            'subtitle'     => 'Item Subtitle 2',
            'title'        => 'Item Title 2',
            'uid'          => 'THE ID 2',
            'valid'        => true,
        },
        {
            'subtitle'     => 'Item Subtitle',
            'title'        => 'Item Title',
            'uid'          => 'THE ID',
            'valid'        => true,
        }
      ]
    }

    assert_equal expected.to_json, @workflow.sort_results('desc').output
  end

  def test_that_it_can_sort_results_by_field
    @workflow.result
                .uid('456')
                .title('Item Title')
                .subtitle('Item Subtitle')

    @workflow.result
                .uid('123')
                .title('Item Title 2')
                .subtitle('Item Subtitle 2')

    expected = {
      'items' => [
        {
            'subtitle'     => 'Item Subtitle 2',
            'title'        => 'Item Title 2',
            'uid'          => '123',
            'valid'        => true,
        },
        {
            'subtitle'     => 'Item Subtitle',
            'title'        => 'Item Title',
            'uid'          => '456',
            'valid'        => true,
        }
      ]
    }

    assert_equal expected.to_json, @workflow.sort_results('asc', 'uid').output
  end

  def test_that_it_can_filter_results
    @workflow.result
                .uid('456')
                .title('Item Title')
                .subtitle('Item Subtitle')

    @workflow.result
                .uid('123')
                .title('Item Title 2')
                .subtitle('Item Subtitle 2')

    expected = {
      'items' => [
        {
            'subtitle'     => 'Item Subtitle 2',
            'title'        => 'Item Title 2',
            'uid'          => '123',
            'valid'        => true,
        }
      ]
    }

    assert_equal expected.to_json, @workflow.filter_results('Title 2').output
  end

  def test_that_it_can_filter_results_by_property
    @workflow.result
                .uid('456')
                .title('Item Title')
                .subtitle('Item Subtitle')

    @workflow.result
                .uid('123')
                .title('Item Title 2')
                .subtitle('Item Subtitle 2')

    expected = {
      'items' => [
        {
            'subtitle'     => 'Item Subtitle',
            'title'        => 'Item Title',
            'uid'          => '456',
            'valid'        => true,
        }
      ]
    }

    assert_equal expected.to_json, @workflow.filter_results(45, 'uid').output
  end
end
