// describe('Gantt Page', function() {
//   beforeEach(() => {
//     cy.app('clean')
//     cy.appScenario('basic')
//     cy.login('admin@test.com', 'T3$tAdmin')
//     cy.openGantt()
//   })

//   it('Open Gantt overview to display the summary of a Project', function() {
//     cy.get('[data-cy=gantt_view]').within(() => {
//       cy.get('[data-cy=gantt_loading]').contains('Loading').should('be.visible')
//     })
//     cy.logout()
//   })
// })
