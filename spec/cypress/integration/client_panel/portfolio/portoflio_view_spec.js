describe('Portoflio Viewer ', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
  })

  it('Open Portoflio viewer', function() {
    cy.openPortoflioViewer()
  })
})
