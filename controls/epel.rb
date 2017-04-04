require_relative '../helpers/os_queries'

configure_epel = attribute('configure_epel', default: false, description: 'Was EPEL Configured?')
install_epel_packages = attribute('install_epel_packages', default: false, description: 'Was EPEL Configured?')

if os.redhat?
  if configure_epel
    # Verify EPEL is setup
    describe 'EPEL Repo' do
      it 'Setup' do
        expect(file('/etc/yum.repos.d/epel.repo')).to exist
        expect(file('/etc/yum.repos.d/epel.repo').content).to match(/^enabled=1/)
      end
    end
    if install_epel_packages
      # Verify EPEL Packages Installed if Enabled
      describe 'EPEL Installed' do
        it 'Package Installed - htop' do
          expect(package('htop')).to be_installed
        end
      end
    end
  else
    # Verify EPEL is not setup
    describe 'EPEL Repo' do
      it 'Not Setup' do
        # Amazon Linux comes with EPEL Repo setup but not enabled
        expect(file('/etc/yum.repos.d/epel.repo')).to_not exist unless amazon?
        expect(file('/etc/yum.repos.d/epel.repo').content).to_not match(/^enabled=1/)
      end
    end
  end
end
