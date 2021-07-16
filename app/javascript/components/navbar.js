const initUpdateNavbarOnScroll = () => {
  const navbarMobile = document.querySelector('.navbar-lewagon');
  const navbarDesktop = document.querySelector('.navbar-lewagon-desktop');
  if (navbarMobile) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= 100) {
        navbarMobile.classList.add('navbar-lewagon-white');
      } else {
        navbarMobile.classList.remove('navbar-lewagon-white');
      }
    });
  }
  if (navbarDesktop) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= 100) {
        navbarDesktop.classList.add('navbar-lewagon-white');
      } else {
        navbarDesktop.classList.remove('navbar-lewagon-white');
      }
    });
  }
}

export { initUpdateNavbarOnScroll };
