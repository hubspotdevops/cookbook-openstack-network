require_relative 'spec_helper'

describe 'openstack-network::dhcp_agent' do

  describe "ubuntu" do

    before do
      quantum_stubs
      @chef_run = ::ChefSpec::ChefRunner.new ::UBUNTU_OPTS
      @chef_run.converge "openstack-network::dhcp_agent"
    end

    # since our mocked version of ubuntu is precise, our compile
    # utilities should be installed to build dnsmasq
    it "installs dnsmasq build dependencies" do
      [ "build-essential", "pkg-config", "libidn11-dev", "libdbus-1-dev", "libnetfilter-conntrack-dev" ].each do |pkg|
        expect(@chef_run).to install_package pkg
      end
    end

    it "installs quamtum dhcp package" do
      expect(@chef_run).to install_package "quantum-dhcp-agent"
    end

    it "starts the dhcp agent on boot" do
     expect(@chef_run).to set_service_to_start_on_boot "quantum-dhcp-agent"
    end

    describe "/etc/quantum/plugins" do
      before do
        @file = @chef_run.directory "/etc/quantum/plugins"
      end
      it "has proper owner" do
        expect(@file).to be_owned_by "quantum", "quantum"
      end
      it "has proper modes" do
        expect(sprintf("%o", @file.mode)).to eq "700"
      end
    end

    describe "/etc/quantum/dhcp_agent.ini" do
      before do
        @file = @chef_run.template "/etc/quantum/dhcp_agent.ini"
      end
      it "has proper owner" do
        expect(@file).to be_owned_by "quantum", "quantum"
      end
      it "has proper modes" do
        expect(sprintf("%o", @file.mode)).to eq "644"
      end
      it "template contents" do
        pending "TODO: implement"
      end
    end

  end

end
