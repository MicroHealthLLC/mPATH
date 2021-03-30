describe('Kanban Risks View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openKanbanRisk()
  })

  it('Open kanban risks in a facility', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col]').eq(1).within(() => {
        cy.get('[data-cy=kanban_col_title]').contains('Test Risk Stage').should('be.visible')
      })
    })
    cy.logout()
  })

  it('Open and close Kanban risk new form', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col]').eq(1).within(() => {
        cy.get('[data-cy=kanban_add_btn]').should('be.visible').click()
      })
    })
    cy.get('[data-cy=risk_save_btn]').should('be.exist')
    cy.get('[data-cy=risk_close_btn]').click({force: true})
    cy.logout()
  })

  it("Create new risk in kanban risk page", function() {
    cy.fillRiskForm()
    cy.get('[data-cy=risk_save_btn]').click({force: true})
    cy.get('.el-message__content').contains('New test risk in kanban was saved successfully.').should('be.visible')
    cy.logout()
  })

  it("In Risk form if title's field empty, error message display", function() {
    cy.fillRiskForm()
    cy.get(':nth-child(1) > [data-cy=facility_tabs]').click()
    cy.get('[data-cy=risk_name]').clear()
    cy.get('[data-cy=risk_name_error]').contains('The Risk Name field is required.').should('be.visible')
    cy.get('.text-danger.mx-4').contains('Please fill the required fields before submitting').should('be.visible')
    cy.get('[data-cy=risk_close_btn]').click()
    cy.logout()
  })

  it('Update on watch state of a risk', function() {
    cy.get('[data-cy=kanban_col]').eq(1).within(() => {
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=risks]').first().within(() => {
          cy.get('[data-cy=on_watch_icon]').should('be.visible')
        })
        cy.get('[data-cy=risks]').first().click()
      })
    })
    cy.get('[data-cy=risk_on_watch]').click({force: true})
    cy.get('[data-cy=risk_save_btn]').click({force: true})
    cy.get('[data-cy=risk_close_btn]').click({force: true})
    cy.get('[data-cy=kanban_col]').eq(1).within(() => {
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=risks]').first().within(() => {
          cy.get('[data-cy=on_watch_icon]').should('not.exist')
        })
      })
    })
    cy.logout()
  })

  it('Drag a risk from first stage and drop it to next stage', function() {
    cy.get('[data-cy=kanban_col]').eq(1).within(() => {
      cy.get('[data-cy=risks]').first().as('origin')
    })

    cy.get('[data-cy=kanban_col]').last().within(() => {
      cy.get('[data-cy=risks]').as('destination')
    })

    cy.get('@origin').drag('@destination', {force: true})

    cy.get('[data-cy=kanban_col]').eq(1).within(() => {
      cy.get('[data-cy=risks]').should('not.exist')
    })

    cy.get('[data-cy=kanban_col]').last().within(() => {
      cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
    })
    cy.logout()
  })

  it('Search risk by typing title', function() {
    cy.get('[data-cy=search_risks]').clear({force: true}).type('Risk is not in the list').should('have.value', 'Risk is not in the list')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=risks]').should('not.exist')
    })

    cy.get('[data-cy=search_risks]').clear({force: true}).type('Test Risk').should('have.value', 'Test Risk')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=risks]').its('length').should('be.eq', 1)
    })

    cy.get('[data-cy=search_risks]').clear({force: true})
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
    })
    cy.logout()
  })
})
