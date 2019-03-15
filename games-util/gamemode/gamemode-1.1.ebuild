# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MULTILIB_USEDEP=( abi_x86_{32,64} )

SRC_URI="https://github.com/FeralInteractive/gamemode/releases/download/${PV}/${P}.tar.xz"
inherit meson ninja-utils multilib-minimal

MY_P="${P/_/-}"
DESCRIPTION="GameMode is a daemon/lib combo for Linux written in C that allows games to request a set of optimisations be temporarily applied to the host OS"
HOMEPAGE="https://github.com/FeralInteractive/gamemode"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-util/meson-0.43.0
	>=dev-util/ninja-1.8.2"
RDEPEND="
	sys-apps/dbus[user-session]
	sys-apps/systemd:=[${MULTILIB_USEDEP}]"

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	local emesonargs=(
		-Dwith-systemd-user-unit-dir=/etc/systemd/user
	)
	meson_src_configure
}

multilib_src_compile() {
	eninja
}

multilib_src_install() {
	DESTDIR=${D} eninja install
}

pkg_postinst() {
	elog "gamemoded has now been installed and can be run with as your user:"
	elog "'systemctl --user enable gamemoded' to enable at boot"
	elog "'systemctl --user start gamemoded' to start now"
	elog ""
	elog "Add 'LD_PRELOAD=$LD_PRELOAD:/usr/\$LIB/libgamemodeauto.so %command%'"
	elog "to the start options to any steam game to enable the performance"
	elog "governor as you start the game"
}
