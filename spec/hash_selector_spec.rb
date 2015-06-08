RSpec.describe "HashSelector" do

  let(:data) { { foo: {
                   bar: [
                     { baz: 1,
                       name: "alice"},
                     { baz: 2,
                       name: "bob"}
                   ] },
                 qux: 42 } }

  it "has a useful to_s" do
    expect( HashSelector.new[:foo].find{true}[:bar].to_s )
      .to eq "HashSelector.new[:foo].find{...}[:bar]"
  end

  it "can select values from top level" do
    expect(
      HashSelector.new[:qux]
      .find_in(data)
    ).to eq 42
  end

  it "raises error on a index miss" do
    expect {
      HashSelector.new[:quux].find_in(data)
    }.to raise_error KeyError
  end

  it "returns value of default value block on a index miss" do
    expect(
      HashSelector.new[:quux].find_in(data) { "whatever" }
    ).to eq "whatever"
  end

  it "can select deeply nested values" do
    expect( HashSelector.new[:foo][:bar][0][:baz].find_in(data)
          ).to eq 1
  end

  it "raise error on a array index miss" do
    expect { HashSelector.new[:foo][:bar][42].find_in(data)
    }.to raise_error KeyError, %r/\[:foo\]\[:bar\]\[42\]/
  end

  it "returns value of default value block a array index miss" do
    expect(
      HashSelector.new[:foo][:bar][42].find_in(data) { "whatever" }
    ).to eq "whatever"
  end

  it "can select path using #find" do
    expect(
      HashSelector.new[:foo][:bar].find{|it| it[:name] == "bob"}[:baz].find_in(data)
    ).to eq 2
  end

  it "can select path using #detect" do
    expect(
      HashSelector.new[:foo][:bar].detect{|it| it[:name] == "bob"}[:baz]
      .find_in(data)
    ).to eq 2
  end

  it "raises error on a #find/#detect miss" do
    expect {
      HashSelector.new[:foo][:bar].detect{|it| it[:name] == "mallory"}
        .find_in(data)
    }.to raise_error KeyError, %r/\[:foo\]\[:bar\].find{...}/
  end

  it "returns value of default value block on a #find/#detect miss" do
    expect(
      HashSelector.new[:foo][:bar].detect{|it| it[:name] == "mallory"}
        .find_in(data) { "whatever" }
    ).to eq "whatever"
  end

end
